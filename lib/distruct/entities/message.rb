class Message < Hanami::Entity
  def available?
    !(self.remove || expired)
  end

  def un_available?
    !available?
  end

  private

  def expired
    self_destruction_time < Time.now
  end
end
