module BenefitSponsors
  module Organizations
    class OrganizationForms::PhoneForm
      include Virtus.model
      include ActiveModel::Validations

      attribute :id, String
      attribute :kind, String
      attribute :area_code, String
      attribute :number, String
      attribute :extension, String
      attribute :office_kind_options, Array
      
      validates_presence_of :kind, :area_code, :number, :state, :zip


      def persisted?
        false
      end

    end
  end
end