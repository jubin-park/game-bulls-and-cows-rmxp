module SceneManager
  @@scene = nil

  def self.switch(klass)
    @@scene = nil
    @@scene = klass.new()
  end

  def self.now
    @@scene
  end
end