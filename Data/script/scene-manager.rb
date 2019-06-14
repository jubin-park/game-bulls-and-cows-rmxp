module SceneManager
  @@scene = nil

  def self.switch(klass)
    @@scene = nil
    GC.start
    @@scene = klass.new
  end

  def self.now
    @@scene
  end
end