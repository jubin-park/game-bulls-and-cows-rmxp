module InputManager

  VK_LBUTTON = 0x1
  VK_RBUTTON = 0x2
  VK_MBUTTON = 0x4
  WHEEL_DELTA = 120
  
  HWND = Win32API.get_hwnd
  Point = Struct.new(:x, :y)
  @@mouse_pos = Point.new(nil, nil)

  def self.update
    @@mouse_pos.x, @@mouse_pos.y = get_mouse_pos(get_mouse_pos_in_screen)
  end

  def self.x
    return @@mouse_pos.x
  end

  def self.y
    return @@mouse_pos.y
  end

  def self.mouse_trigger?(key)
    return Win32API::GetAsyncKeyState.call(key) & 0x1 == 0x1
  end

  def self.mouse_press?(key)
    return Win32API::GetAsyncKeyState.call(key) & 0x8000 == 0x8000
  end

  def self.mouse_wheel(delta, keys, x, y)
    @@delta += delta
    if @@delta.abs >= WHEEL_DELTA
      delta_idx = - @@delta / WHEEL_DELTA
      @@delta %= WHEEL_DELTA
    end
    @wheel = delta_idx
  end
  if !defined? Wheel
    Wheel = Win32API.new('rm-mouse-wheel', 'intercept', 'v', 'v')
    Wheel.call
    @@delta = 0
  end

  def self.get_mouse_pos(pos)
    return nil if pos == nil
    pos = pos.pack('ii')
    return pos.unpack('ii') if Win32API::ScreenToClient.call(HWND, pos) != 0
    return nil
  end

  def self.get_mouse_pos_in_screen
    pos = [0, 0].pack('ii')
    return pos.unpack('ii') if Win32API::GetCursorPos.call(pos) != 0
    return nil
  end
end
