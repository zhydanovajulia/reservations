require "spec_helper"

describe Reservation do
  let(:time) { DateTime.current }
  let!(:reservation) { create :reservation, start_time: time+3.hours, end_time: time+7.hours, table_number: 10 }
  let(:reservation1) { build :reservation, start_time: time-3.hours, end_time: time+3.hours, table_number: 2 }
  let(:reservation2) { build :reservation, start_time: time+3.hours, end_time: time+1.hour, table_number: 2 }

  it { should respond_to(:table_number, :start_time, :end_time) }
  it { should validate_presence_of :table_number}
  it { should validate_presence_of :start_time}
  it { should validate_presence_of :end_time}

  it "start time should not be in the past" do
    reservation1.should_not be_valid
    reservation1.errors.full_messages.should include("Start time can't be in the past")
  end

  it "start time should go before the end time" do
    reservation2.should_not be_valid
    reservation2.errors.full_messages.should include("Start time can't go after the end time")
  end

  it 'should not raise time intersection error' do
    reservation.should be_valid
  end

  it 'should not raise time intersection error after update' do
    reservation.update_attributes start_time: time+4.hours
    reservation.should be_valid
  end

  it "should raise 'Time intersection' error when start_time goes between time range" do
    invalid_reservation = build :reservation, start_time: time+4.hours, end_time: time+8.hours, table_number: 10
    invalid_reservation.should_not be_valid
    invalid_reservation.errors.full_messages.should include("Time intersection")
  end

  it "should raise 'Time intersection' error when end_time goes between time range" do
    invalid_reservation = build :reservation, start_time: time+1.hours, end_time: time+5.hours, table_number: 10
    invalid_reservation.should_not be_valid
    invalid_reservation.errors.full_messages.should include("Time intersection")
  end

  it "should not raise 'Time intersection' error - intersection" do
    invalid_reservation = build :reservation, start_time: time+3.hours, end_time: time+6.hours, table_number: 9
    invalid_reservation.should be_valid
  end

  it "should raise 'Time intersection' error - overlapping" do
    invalid_reservation = build :reservation, start_time: time+1.hours, end_time: time+8.hours, table_number: 10
    invalid_reservation.should_not be_valid
    invalid_reservation.errors.full_messages.should include('Time intersection')
  end

  it "should not raise 'Time intersection' error - overlapping" do
    invalid_reservation = build :reservation, start_time: time+1.hours, end_time: time+8.hours, table_number: 7
    invalid_reservation.should be_valid
  end
end