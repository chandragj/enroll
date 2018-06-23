# Profile
# Base class with attributes, validations and constraints common to all Profile classes
# embedded in an Organization
module BenefitSponsors
  module Organizations
    class Profile
      include Mongoid::Document
      include Mongoid::Timestamps

      embedded_in :organization,  class_name: "BenefitSponsors::Organizations::Organization"

      # Profile subclass may sponsor benefits
      field :is_benefit_sponsorship_eligible, type: Boolean,  default: false
      field :contact_method,                  type: Symbol,   default: :paper_and_electronic

      # TODO: Add logic to manage benefit sponsorships for Gapped coverage, early termination, banned employers

      # Share common attributes across all Profile kinds
      delegate :hbx_id,                                 to: :organization, allow_nil: false
      delegate :legal_name,               :legal_name=, to: :organization, allow_nil: false
      delegate :dba,                      :dba=,        to: :organization, allow_nil: true
      delegate :fein,                     :fein=,       to: :organization, allow_nil: true

      embeds_many :office_locations,
                  class_name:"BenefitSponsors::Locations::OfficeLocation"

      embeds_one  :inbox, as: :recipient, cascade_callbacks: true,
                  class_name:"BenefitSponsors::Inboxes::Inbox"

      # Use the Document model for managing any/all documents associated with Organization
      has_many :documents, as: :documentable,
               class_name: "BenefitSponsors::Documents::Document"

      validates_presence_of :office_locations, :contact_method
      accepts_nested_attributes_for :office_locations, allow_destroy: true

      # @abstract profile subclass is expected to implement #initialize_profile
      # @!method initialize_profile
      # Initialize settings for the abstract profile
      after_initialize :initialize_profile, :build_nested_models

      alias_method :is_benefit_sponsorship_eligible?, :is_benefit_sponsorship_eligible

      # # TODO make benefit sponsorships a has_many collection
      # # Inverse of BenefitSponsoship#organization_profile
      # def benefit_sponsorship
      #   raise Errors::SponsorshipIneligibleError unless is_benefit_sponsorship_eligible?
      #   return @benefit_sponsorship if defined?(@benefit_sponsorship)
      #   @benefit_sponsorship = organization.benefit_sponsorships.detect { |benefit_sponsorship| benefit_sponsorship._id == self.benefit_sponsorship_id }
      # end

      # def benefit_sponsorship=(benefit_sponsorship)
      #   return unless is_benefit_sponsorship_eligible?
      #   write_attribute(:benefit_sponsorship_id, benefit_sponsorship._id)
      #   @benefit_sponsorship = benefit_sponsorship
      # end

       validates :contact_method,
         inclusion: { in: ::BenefitMarkets::CONTACT_METHOD_KINDS, message: "%{value} is not a valid contact method" },
         allow_blank: false

      def primary_office_location
        office_locations.detect(&:is_primary?)
      end

      def is_primary_office_local?
        primary_office_location.address.state.to_s.downcase == Settings.aca.state_abbreviation.to_s.downcase
      end

      def add_benefit_sponsorship
        organization.sponsor_benefits_for(self) if is_benefit_sponsorship_eligible? && organization.present?
      end

      def benefit_sponsorships
        organization.benefit_sponsorships.select { |benefit_sponsorship| benefit_sponsorship.profile_id.to_s == _id.to_s }
      end

      def latest_benefit_sponsorship
        organization.latest_benefit_sponsorship_for(self)
      end

      def benefit_sponsorship_successors_for(benefit_sponsorship)
        organization.benefit_sponsorships.select { |organization_sponsorship| organization_sponsorship.predecessor_sponsorship_id == benefit_sponsorship._id }
      end

      def contact_methods
        ::BenefitMarkets::CONTACT_METHODS_HASH
      end

      def staff_roles #managing profile staff
        Person.staff_for_employer(self)
      end

      class << self
        def find(id)
          return nil if id.blank?
          organization = BenefitSponsors::Organizations::Organization.where("profiles._id" => BSON::ObjectId.from_string(id)).first
          organization.profiles.detect { |profile| profile.id.to_s == id.to_s } if organization.present?
        end
      end

      def legal_name
        organization.legal_name
      end

      def self.by_hbx_id(an_hbx_id)
        organization = BenefitSponsors::Organizations::Organization.where(hbx_id: an_hbx_id, profiles: {"$exists" => true})
        return nil unless organization.any?
        organization.first.employer_profile
      end

      private

      # Subclasses may extend this method
      def initialize_profile
      end

      # Subclasses may extend this method
      def build_nested_models
      end
    end
  end
end
