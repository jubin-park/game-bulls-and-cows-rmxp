module InputManager

  VK_LBUTTON = 0x1
  VK_RBUTTON = 0x2
  VK_MBUTTON = 0x4
  HWND = Win32API.get_hwnd
  @@struct_pos = Struct.new(:x, :y).new(nil, nil)

  def self.update
    @@struct_pos.x, @@struct_pos.y = get_mouse_pos(get_mouse_pos_in_screen)
  end

  def self.x
    return @@struct_pos.x
  end

  def self.y
    return @@struct_pos.y
  end

  def self.mouse_trigger?(key)
    return Win32API::GetAsyncKeyState.call(key) & 0x1 == 0x1
  end

  def self.mouse_press?(key)
    return Win32API::GetAsyncKeyState.call(key) & 0x8000 == 0x8000
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