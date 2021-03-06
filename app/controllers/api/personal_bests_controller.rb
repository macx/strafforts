module Api
  class PersonalBestsController < ApplicationController
    def index # rubocop:disable MethodLength, CyclomaticComplexity, AbcSize, PerceivedComplexity
      athlete = Athlete.find_by(id: params[:id])
      ApplicationController.raise_athlete_not_found_error(params[:id]) if athlete.nil?

      athlete = athlete.decorate
      heart_rate_zones = ApplicationHelper::Helper.get_heart_rate_zones(athlete.id)

      results = []
      unless params[:distance].blank?
        if 'overview'.casecmp(params[:distance]).zero?
          items = BestEffort.find_all_pbs_by_athlete_id(athlete.id)
          shaped_items = ApplicationHelper::Helper.shape_best_efforts(
            items, heart_rate_zones, athlete.athlete_info.measurement_preference
          )
          @personal_bests = PersonalBestsDecorator.new(shaped_items)
          results = @personal_bests.to_show_in_overview
        elsif 'recent'.casecmp(params[:distance]).zero?
          items = BestEffort.find_all_pbs_by_athlete_id(athlete.id)
          shaped_items = ApplicationHelper::Helper.shape_best_efforts(
            items, heart_rate_zones, athlete.athlete_info.measurement_preference
          )
          results = shaped_items.first(RECENT_ITEMS_LIMIT)
        else
          # Get best_effort_type from distance parameter.
          # '1/2 mile' should be passed in as 1_2-mile, 'Half Marathon' is passed in as half-marathon
          # as defined in createView method in app/assets/javascripts/athletes/views/navigationSidebar.ts.
          distance = params[:distance].tr('_', '/').tr('-', ' ')
          best_effort_type = BestEffortType.find_by_name(distance)
          if best_effort_type.nil?
            Rails.logger.warn("Could not find requested best effort type '#{distance}' for athlete '#{athlete.id}'.")
            render json: { error: ApplicationHelper::Message::DISTANCE_NOT_FOUND }.to_json, status: 404
            return
          end

          # Return 403 Forbidden if free-account athlete tries to access non-major distances.
          major_distance = ApplicationHelper::Helper.major_best_effort_types.select do |item|
            item[:name] == best_effort_type.name
          end
          if major_distance.blank? && !athlete.pro_subscription?
            render json: { error: ApplicationHelper::Message::PRO_ACCOUNTS_ONLY }.to_json, status: 403
            return
          end

          items = BestEffort.find_all_pbs_by_athlete_id_and_best_effort_type_id(athlete.id, best_effort_type.id)
          results = ApplicationHelper::Helper.shape_best_efforts(
            items, heart_rate_zones, athlete.athlete_info.measurement_preference
          )
        end
      end
      render json: results
    end
  end
end
