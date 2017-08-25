
require File.join(Rails.root, "lib/mongoid_migration_task")

class ChangeEnrollmentDetails < MongoidMigrationTask
  def migrate
    @enrollment = get_enrollment
    action = ENV['action'].to_s

    case action
    when "change_effective_date"
      change_effective_date
    when "revert_termination"
      revert_termination
    when "terminate"
      terminate_enrollment
    when "revert_cancel"
      # When Enrollment with given policy ID is active in Glue & canceled in Enroll(Mostly you will see this with passive enrollments)
      revert_cancel
    when "cancel", "cancel_enrollment"
      cancel_enr
    when "generate_hbx_signature"
      generate_hbx_signature
    when "expire_coverage"
      expire_coverage
    end
  end

  def get_enrollment
    enrollments = HbxEnrollment.by_hbx_id(ENV['hbx_id'].to_s)
    if enrollments.size != 1
      raise "Found no (OR) more than 1 enrollments with the given hbx id" unless Rails.env.test?
    end
    enrollments.first
  end

  def change_effective_date
    if ENV['new_effective_on'].blank?
      raise "Input required: effective on" unless Rails.env.test?
    end
    new_effective_on = Date.strptime(ENV['new_effective_on'].to_s, "%m/%d/%Y")
    @enrollment.update_attributes!(:effective_on => new_effective_on)
    puts "Changed Enrollment effective on date to #{new_effective_on}" unless Rails.env.test?
  end

  def revert_termination
    @enrollment.update_attributes!(terminated_on: nil, termination_submitted_on: nil, aasm_state: "coverage_enrolled")
    @enrollment.hbx_enrollment_members.each { |mem| mem.update_attributes!(coverage_end_on: nil)}
    puts "Reverted Enrollment termination" unless Rails.env.test?
  end

  def terminate_enrollment
    terminated_on = Date.strptime(ENV['terminated_on'].to_s, "%m/%d/%Y")
    @enrollment.update_attributes!(terminated_on: terminated_on)
    @enrollment.terminate_coverage! if @enrollment.may_terminate_coverage?
    puts "terminate enrollment on #{terminated_on}" unless Rails.env.test?
  end

  def revert_cancel
    @enrollment.update_attributes(aasm_state: "coverage_enrolled")
    puts "Moved enrollment to Enrolled status from canceled state" unless Rails.env.test?
  end

  def cancel_enr
    @enrollment.cancel_coverage! if @enrollment.may_cancel_coverage?
    puts "canceled enrollment with hbx_id: #{@enrollment.hbx_id}" unless Rails.env.test?
  end

  def generate_hbx_signature
    @enrollment.generate_hbx_signature
    @enrollment.save!
    puts "enrollment_signature generated #{@enrollment.enrollment_signature}" unless Rails.env.test?
  end

  def expire_coverage
    @enrollment.expire_coverage! if @enrollment.may_expire_coverage?
    puts "moved enrollment with hbx_id: #{@enrollment.hbx_id} to expired status" unless Rails.env.test?
  end
end
