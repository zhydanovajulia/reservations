class Reservation < ActiveRecord::Base
  validates :table_number, :start_time, :end_time, presence: true
  validate :time_intersection
  validate :time_in_the_past
  validate :time_range

  scope :table, -> (table_number){ where(table_number: table_number) }

  private

  def time_in_the_past
    self.errors.add(:start_time, "can't be in the past") if self.start_time && self.start_time < DateTime.current
  end

  def time_range
    self.errors.add(:start_time, "can't go after the end time") if self.start_time && self.start_time > self.end_time && self.end_time
  end

  def time_intersection
    if self.class.table(self.table_number).where.not(id: self.id).where("(start_time <= :start_time AND end_time > :start_time)
                                                  OR (start_time < :end_time AND end_time >= :end_time)
                                                  OR(start_time >= :start_time AND end_time <= :end_time)",
      start_time: self.start_time, end_time: self.end_time).any?
      self.errors.add(:time, 'intersection')
    end
  end
end