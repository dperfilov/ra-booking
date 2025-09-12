class BookingsController < ApplicationController
  layout "bookings_layout"

  class_attribute :client
  BookingsController.client = Savon.client(
      # wsdl: 'http://192.168.0.116:40001/?wsdl',
      wsdl: 'wsdl/ra_merged.wsdl',
      endpoint: 'http://192.168.0.116:40001/',
      # namespace: 'http://www.reservationassistant.com/Configuration/Types',
      log: true,        # для отладки
      pretty_print_xml: true,
      env_namespace: 'soapenv',
      # namespace_identifier: nil,
      # soap_version: 2,
      # namespace_identifier: :ins0,
      element_form_default: :qualified,

      # headers: {
      # }

      # namespaces: {
      #   'xmlns:typ' => "http://www.reservationassistant.com/Configuration/Types",
      #   'xmlns:typ1' => "http://www.reservationassistant.com/Common/Types"
      # },

      convert_request_keys_to: :none
    )


  def index
    logger.debug "======"
  end

  def stage1
    logger.debug "======"
  end

  def get_time_slots
    @time_slots = []
    restId = params[:rest]
    @requested_date = params[:date][:requested_date].to_date


    message = { 
      :Restaurants => {
        :RestaurantIDs => {
          :UniqueID => {
            :@source => 'TAC',
            :content! => restId
          }
        }
      },
      :TimeSpan => {
        :Start => @requested_date,
        :End => @requested_date+1
      }
    }

    response = BookingsController.client.call(:fetch_restaurant_opening_hours, message: message).body
    opening_hour = response.dig(:fetch_restaurant_opening_hours_response, :restaurant_opening_hours, :restaurant_opening_hour)
    @rest_short_name = opening_hour[:restaurant_shortname].to_s


    location = opening_hour.dig(:locations, :location)[0]
    service_period = location.dig(:service_periods, :service_period)[0]

    service_period_opening_details = service_period.dig(:service_period_openings, :service_period_opening, :service_period_opening_details)
    start_time = service_period_opening_details.dig(:service_period_opening_detail, :seatings, :seating, :start_times, :start_time)
    start_time.each {|slot|
      @time_slots.push(slot[:start_time].to_s)
    }

    @out = opening_hour

    render "stage2"
  end

  def stage1_get_rests
    @rests = []

    message = { 
      :TemplateCategoryIDs => {
        :UniqueID => {
          :@source => 'TAC',
          :content! => '4727'
        }
      }
    }
    response = BookingsController.client.call(:template_info, message: message)
    templates = response.body[:template_info_response][:templates][:template]

    templates.each {|template| 
      rest = []
      rest.push(template[:name].to_s)
      rest.push(template[:template_i_ds][:unique_id].to_s)

      @rests.push(rest)
    }

    @out = templates

    render "stage1"
  end

end
