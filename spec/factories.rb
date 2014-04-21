FactoryGirl.define do
  factory :reservation do
    sequence(:table_number) { |n| n }
    start_time DateTime.current
    end_time { start_time + 3.hours }
  end
end
