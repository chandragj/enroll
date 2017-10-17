module Observers
  class Observer
    include Acapi::Notifiers

    def trigger_notice(receipient, notice_event)
      resource_mapping = Notifier::ApplicationEventMapper.map_resource(receipient.class)
      event_name = Notifier::ApplicationEventMapper.map_event_name(resource_mapping, notice_event)
      notify(event_name, {
        resource_mapping.identifier_key => receipient.send(resource_mapping.identifier_method).to_s
      })
    end
  end
end