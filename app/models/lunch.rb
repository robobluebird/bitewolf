class Lunch
  include Mongoid::Document
  include Mongoid::Timestamps

  field :day, type:String
  field :time, type:String
  field :time_message, type:String
  field :upvotes_count, type:Integer
  field :chosen_location_id, type:String
  field :chosen_by, type:Symbol
  field :choser_id, type:String

  embedded_in :group
  embeds_many :locations

  def complete?
    # time_diff = (DateTime.now - DateTime.strptime(self.day + " " + self.time, '%m/%d/%Y %H:%M %p')) * 24 * 60
    # self.tallied? && self.chosen_by == :vote || time_diff <= 60
    false
  end

  def tallied?
    self.chosen_location_id != nil
  end

  def sort_locations_by_upvotes!
    self.locations.sort! do |x, y|
      y.upvotes.count <=> x.upvotes.count
    end

    self
  end

  def remove_voter_upvotes!(voter)
    deleted = false
    self.locations.map! do |location|
      if location.upvotes.delete(voter)
        deleted = true
      end
      location
    end

    self.save
    deleted
  end

  def count_upvotes
    self.locations.reduce(0) do |memo, item|
      memo += item.upvotes.count
    end
  end

  def voting_complete?
    self.count_upvotes == self.group.users.count
  end

  def decide_winner
    max_votes = self.locations.map{|l| l.upvotes.count}.max

    top_locations = self.locations.reduce([]) do |arr, loc|
      if loc.upvotes.count == max_votes
        arr << loc
      end
      arr
    end

    if top_locations.count > 1
      if self.chosen_location_id != nil
        self.chosen_location_id = nil
        self.chosen_by = nil
      end

      # rand_location = top_locations[rand(0...top_locations.count)]

      # self.chosen_location_id = rand_location.id
      # self.chosen_by = :rand
      # self.group.last_rand = rand_location.suggester_id
    else
      self.chosen_location_id = top_locations.first.id
      self.chosen_by = :vote
    end

    self.save
  end

  def tally
    if self.voting_complete?
      self.decide_winner
    else
      if self.chosen_location_id != nil
        self.chosen_location_id = nil
        self.chosen_by = nil
        self.save
      end
    end
  end
end
