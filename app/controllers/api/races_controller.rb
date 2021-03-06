module Api
  class RacesController < ApplicationController
    def index # rubocop:disable AbcSize, MethodLength, CyclomaticComplexity, PerceivedComplexity
      athlete = Athlete.find_by(id: params[:id])
      ApplicationController.raise_athlete_not_found_error(params[:id]) if athlete.nil?

      athlete = athlete.decorate
      heart_rate_zones = ApplicationHelper::Helper.get_heart_rate_zones(athlete.id)

      results = []
      unless params[:distance_or_year].blank?
        if 'overview'.casecmp(params[:distance_or_year]).zero?
          items = Race.find_all_by_athlete_id(athlete.id)
          shaped_items = ApplicationHelper::Helper.shape_races(
            items, heart_rate_zones, athlete.athlete_info.measurement_preference
          )
          @races = RacesDecorator.new(shaped_items)
          results = @races.to_show_in_overview
        elsif 'recent'.casecmp(params[:distance_or_year]).zero?
          items = Race.find_all_by_athlete_id(athlete.id)
          shaped_items = ApplicationHelper::Helper.shape_races(
            items, heart_rate_zones, athlete.athlete_info.measurement_preference
          )
          results = shaped_items.first(RECENT_ITEMS_LIMIT)
        elsif params[:distance_or_year] =~ /^20\d\d$/
          unless athlete.pro_subscription?
            render json: { error: ApplicationHelper::Message::PRO_ACCOUNTS_ONLY }.to_json, status: 403
            return
          end

          year = params[:distance_or_year]
          items = Race.find_all_by_athlete_id_and_year(athlete.id, year)

          if items.blank? # Return 404 if nothing found for this year.
            Rails.logger.warn("Could not find requested race year '#{year}' for athlete '#{athlete.id}'.")
            render json: { error: ApplicationHelper::Message::YEAR_NOT_FOUND }.to_json, status: 404
            return
          end

          results = ApplicationHelper::Helper.shape_races(
            items, heart_rate_zones, athlete.athlete_info.measurement_preference
          )
        else
          # Get race distance from distance_or_year parameter.
          # 'Half Marathon' is passed in as half-marathon
          # as defined in createView method in athletes/races.js, revert back when before searching here.
          distance = params[:distance_or_year].tr('|', '/').tr('-', ' ')
          race_distance = RaceDistance.find_by_name(distance)
          if race_distance.nil?
            Rails.logger.warn("Could not find requested race distance '#{distance}' for athlete '#{athlete.id}'.")
            render json: { error: ApplicationHelper::Message::DISTANCE_NOT_FOUND }.to_json, status: 404
            return
          end

          # Return 403 Forbidden if free-account athlete tries to access non-major distances.
          major_distance = ApplicationHelper::Helper.major_race_distances.select do |item|
            item[:name] == race_distance.name
          end
          if major_distance.blank? && !athlete.pro_subscription?
            render json: { error: ApplicationHelper::Message::PRO_ACCOUNTS_ONLY }.to_json, status: 403
            return
          end

          items = Race.find_all_by_athlete_id_and_race_distance_id(athlete.id, race_distance.id)
          results = ApplicationHelper::Helper.shape_races(
            items, heart_rate_zones, athlete.athlete_info.measurement_preference
          )
        end
      end
      render json: results
    end
  end
end
