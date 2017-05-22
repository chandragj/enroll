module ScheduledEventService
  extend ActiveSupport::Concern

  included do
    # has_many employers
    def self.individual_market_monthly_enrollment_due_on
      @individual_market_monthly_enrollment_due_on ||=
           ScheduledEvent.where(:event_name => "ivl_monthly_enrollment_due_on").first.try(:start_time).try(:day) || Setting.individual_market_monthly_enrollment_due_on
    end

    def self.shop_market_binder_payment_due_on
      @shop_market_binder_payment_due_on ||=
          ScheduledEvent.where(:event_name => "shop_binder_payment_due_on").first.try(:start_time).try(:day) || Settings.aca.shop_market.binder_payment_due_on
    end

    def self.shop_market_initial_application_publish_due_day_of_month
      @shop_market_initial_application_publish_due_day_of_month ||=
          ScheduledEvent.where(:event_name => "shop_initial_application_publish_due_day_of_month").first.try(:start_time).try(:day) || Settings.aca.shop_market.initial_application.publish_due_day_of_month
    end

    def self.shop_market_renewal_application_monthly_open_enrollment_end_on
      @shop_market_renewal_application_monthly_open_enrollment_end_on ||=
          ScheduledEvent.where(:event_name => "shop_renewal_application_monthly_open_enrollment_end_on").first.try(:start_time).try(:day) || Settings.aca.shop_market.renewal_application.monthly_open_enrollment_end_on
    end

    def self.shop_market_renewal_application_publish_due_day_of_month
      @shop_market_renewal_application_publish_due_day_of_month ||=
          ScheduledEvent.where(:event_name => "shop_renewal_application_publish_due_day_of_month").first.try(:start_time).try(:day) || Settings.aca.shop_market.renewal_application.publish_due_day_of_month
    end

    def self.shop_market_renewal_application_force_publish_day_of_month
      @shop_market_renewal_application_force_publish_day_of_month ||=
          ScheduledEvent.where(:event_name => "shop_renewal_application_force_publish_day_of_month").first.try(:start_time).try(:day) || Settings.aca.shop_market.renewal_application.force_publish_day_of_month
    end

    def self.shop_market_open_enrollment_monthly_end_on
      @shop_market_open_enrollment_monthly_end_on ||=
          ScheduledEvent.where(:event_name => "shop_open_enrollment_monthly_end_on").first.try(:start_time).try(:day) || Settings.aca.shop_market.open_enrollment.monthly_end_on
    end

    def self.shop_market_group_file_new_enrollment_transmit_on
      @shop_market_group_file_new_enrollment_transmit_on ||=
          ScheduledEvent.where(:event_name => "shop_group_file_new_enrollment_transmit_on").first.try(:start_time).try(:day) || Settings.aca.shop_market.group_file.new_enrollment_transmit_on
    end

    def self.shop_market_group_file_update_transmit_day_of_week
      @shop_market_group_file_update_transmit_day_of_week ||=
          ScheduledEvent.where(:event_name => "shop_group_file_update_transmit_day_of_week").first.try(:start_time).try(:day) || Settings.aca.shop_market.group_file.update_transmit_day_of_week
    end
  end
end