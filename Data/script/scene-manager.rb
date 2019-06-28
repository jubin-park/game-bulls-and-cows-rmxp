module SceneManager
  @@scene = nil

  def self.switch(klass, *args)
    @@scene = nil
    GC.start
    @@scene = klass.new(args)
  end

  def self.now
    @@scene
  end
end