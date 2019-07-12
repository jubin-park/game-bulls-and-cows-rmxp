module SceneManager
  @@now_scene = nil
  @@previous_scene = nil

  def self.switch(klass, *args)
    @@previous_scene = @@now_scene
    @@now_scene = nil
    GC.start
    @@now_scene = klass.new(args)
  end

  def self.now
    @@now_scene
  end

  def self.now=(value)
    @@now_scene = value
  end

  def self.previous
    @@previous_scene
  end
end