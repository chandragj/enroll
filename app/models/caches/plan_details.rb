module Caches
  class PlanDetails
    def self.lookup_rate_with_area(plan_id, rate_schedule_date, effective_age, rating_area)
      calc_age = age_bounding(plan_id, effective_age)
      pt = $plan_age_lookup_with_rating_area[plan_id][calc_age][0]
      status = (pt[:start_on] <= rate_schedule_date) && (pt[:end_on] >= rate_schedule_date) && (pt[:rating_area] == rating_area)
      pt[:cost] if status
    rescue
      0
    end

    def self.lookup_rate(plan_id, rate_schedule_date, effective_age)
      calc_age = age_bounding(plan_id, effective_age)
      age_record = $plan_age_lookup[plan_id][calc_age].detect do |pt|
        (pt[:start_on] <= rate_schedule_date) && (pt[:end_on] >= rate_schedule_date)
      end
      age_record[:cost]
    rescue
      0
    end 

    def self.age_bounding(plan_id, given_age)
      plan_age = $plan_age_bounds[plan_id]
      return plan_age[:minimum] if given_age < plan_age[:minimum]
      return plan_age[:maximum] if given_age > plan_age[:maximum]
      given_age 
    end

    def self.load_record_cache!
      $plan_age_bounds = {}
      $plan_age_lookup = {}
      Plan.all.each do |plan|
        $plan_age_bounds[plan.id] = {
          :minimum => plan.minimum_age,
          :maximum => plan.maximum_age
        }
        $plan_age_lookup[plan.id] = {}
        plan.premium_tables.each do |pt|
          unless $plan_age_lookup[plan.id].has_key?(pt.age)
            $plan_age_lookup[plan.id][pt.age] = []
          end
          $plan_age_lookup[plan.id][pt.age].push(
            {
              :start_on => pt.start_on,
              :end_on => pt.end_on,
              :cost => pt.cost
            }
          )
        end 
      end
    end

    def self.load_record_cache_with_rating_area!
      $plan_age_lookup_with_rating_area = $plan_age_lookup
      Plan.all.each do |plan|
        plan.premium_tables.each do |pt|
          unless $plan_age_lookup_with_rating_area[plan.id][pt.age][0].has_key?(:rating_area)
            $plan_age_lookup_with_rating_area[plan.id][pt.age][0][:rating_area] = pt.rating_area
          end
        end
      end
    end

  end
end
