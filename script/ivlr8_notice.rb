
  enrollment_group_ids = []
  plans_2016 = {}
  begin
    csv = CSV.open('11455_report.csv',"r",:headers =>true,:encoding => 'ISO-8859-1')
    @data= csv.to_a
    @data.each do |d|
        enrollment_group_ids << d["policy.eg_id"]
        plans_2016[d["policy.eg_id"]] = d["2016_plan_hios"]
    end
  rescue Exception => e
    puts "Unable to open file #{e}"
  end

  enrollment_group_ids.uniq!
  families = Family.where("households.hbx_enrollments" => {"$exists" => true}, "households.hbx_enrollments.hbx_id" => {"$in" => enrollment_group_ids})

  field_names  = %w(
          person.hbx_id
          person.full_name
        )
  file_name = "#{Rails.root}/public/ivl_renewal_notice_8_report.csv"

  CSV.open(file_name, "w", force_quotes: true) do |csv|
    csv << field_names

    event_kind = ApplicationEventKind.where(:event_name => 'ivl_renewal_notice_8').first

    notice_trigger = event_kind.notice_triggers.first

    families.each do |fam|
      begin
        primary_member = fam.primary_applicant.person
        # person = Person.where(:hbx_id => primary_member["person.authority_member_id"]).first
        consumer_role =primary_member.consumer_role
        if consumer_role.present?
            builder = notice_trigger.notice_builder.camelize.constantize.new(consumer_role, {
                  template: notice_trigger.notice_template,
                  subject: event_kind.title,
                  mpi_indicator: notice_trigger.mpi_indicator,
                  enrollment_group_ids: enrollment_group_ids,
                  plan_data_2016: plans_2016
                  }.merge(notice_trigger.notice_trigger_element_group.notice_peferences)
                  )
            builder.deliver
          csv << [
              primary_member.hbx_id,
              primary_member.full_name
            ]
        else
          puts "Unable to send notice to family_id : #{fam.id.to_s}"
        end
      rescue Exception => e
        puts "Unable to deliver to #{fam.id.to_s} for the following error #{e.backtrace}"
        next
      end
    end
  end