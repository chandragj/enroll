module Forms
  class BulkActionsForAdmin

    attr_reader :result
    attr_reader :row
    attr_reader :family_id
    attr_reader :params

    def initialize(*arguments)
      @params = arguments.extract_options!
      @result = {success: [], failure: []}
      @row = @params[:family_actions_id]
      @family_id = @params[:family_id]
    end

    def cancel_enrollments
      cancelled_enrollments_transmission_info = {}
      @params.each do |key, value|
        if key.to_s[/cancel_hbx_.*/]
          hbx = HbxEnrollment.find(params[key.to_s])
          begin
            hbx.cancel_coverage! if hbx.may_cancel_coverage?
            @result[:success] << hbx
            cancelled_enrollments_transmission_info[hbx.id] = params.key?("transmit_hbx_#{hbx.id.to_s}") ? true : false
          rescue
            @result[:failure] << hbx
          end
        end
      end
      cancelled_enrollments_transmission_info.each { |hbx_id, transmit_flag| handle_edi_transmissions(hbx_id, transmit_flag) }
    end

    def terminate_enrollments
      terminated_enrollments_transmission_info = {}
      @params.each do |key, value|
        if key.to_s[/terminate_hbx_.*/]
          hbx = HbxEnrollment.find(params[key.to_s])
          begin
            termination_date = Date.strptime(params["termination_date_#{value}"], "%m/%d/%Y")
            hbx.terminate_coverage!(termination_date) if hbx.may_terminate_coverage?
            @result[:success] << hbx
            terminated_enrollments_transmission_info[hbx.id] = params.key?("transmit_hbx_#{hbx.id.to_s}") ? true : false
          rescue
            @result[:failure] << hbx
          end
        end
      end
      terminated_enrollments_transmission_info.each { |hbx_id, transmit_flag| handle_edi_transmissions(hbx_id, transmit_flag) }
    end

    private

    def handle_edi_transmissions(hbx_id, transmit_flag) #transmit_flag = true/false based on wheather the user elected to transmit.
      hbx = HbxEnrollment.find(hbx_id)
      ### Handle EDI transmission here ###
      if transmit_flag

      else

      end
    end
  end
end
