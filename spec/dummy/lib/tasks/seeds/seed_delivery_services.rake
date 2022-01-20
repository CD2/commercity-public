# frozen_string_literal: true

task seed_delivery_services: :environment do
  C::DeliveryServiceProvider.find_each(&:destroy)

  providers = {
    'Courier' => {
      'Standard Delivery' => [
        {
          price: 8,
          max: 99.99
        },
        {
          price: 0,
          min: 100
        }
      ]
    },
    'In store' => {
      '1 Hour Collection' => [
        {
          price: 0
        }
      ]
    }
  }

  providers.each do |provider, services|
    dsp = C::DeliveryServiceProvider.create!(name: provider)

    count = 0
    services.each do |service, prices|
      ds = dsp.delivery_services.create!(
        name: service,
        active: true,
        default: count == 0
      )
      count += 1

      prices.each do |price|
        ds.delivery_service_prices.create!(
          price: price[:price],
          min_cart_price: price[:min] || 0,
          max_cart_price: price[:max]
        )
      end
    end
  end
end
