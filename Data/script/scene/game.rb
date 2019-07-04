class Scene
  class Game
    module ZOrder
      BLACK_SCREEN = 20
      HOLE = 1
      ITEM_CIRCLE = 2
      ITEM = 3
      LIST_BACKGROUND = 4
      LIST_CONTENTS = 5
      BUTTON_TRY = 6
    end

    module Config
      LIST_ITEM_SIZE = 50
      LIST_HEIGHT_PER_LINE = 24
      LIST_HEIGHT = LIST_ITEM_SIZE * LIST_HEIGHT_PER_LINE
      BUTTON_TRY_SHOWED_Y = 210
      BUTTON_TRY_HIDDEN_Y = 320
    end

    def initialize(*args)
      args = *args
      @digit = args[0]
      @item_size = args[1].length
      p @real_answer = generate_answer(args[0], args[1].clone)
      @phase = 0
      @my_answer = Array.new(@digit)
      @now_picked_item = nil
      @sprite_black = Sprite.new
      @sprite_black.bitmap = Bitmap.new(320, 320)
      @sprite_black.bitmap.fill_rect(0, 0, 320, 320, Color.new(0, 0, 0))
      @sprite_black.z = ZOrder::BLACK_SCREEN
      @sprite_background = Sprite.new
      @sprite_background.bitmap = Bitmap.new(640, 320)
      @sprite_background.bitmap.blt(0, 0, Bitmap.new("img/background.png"), Rect.new(0, 0, 320, 320))
      bmp = Bitmap.new("img/hole.png")
      sx = (320 - @digit * 34) / 2
      @button_hole = Array.new(@digit) do |i|
        Button.new(36, 36) do
          {
            :x => sx + i * 34,
            :y => 32,
            :bitmap => [bmp],
            :index => i
          }
        end
      end
      @button_try = Button.new(32, 32) do
        {
          :x => 142,
          :y => 320,
          :bitmap =>
          [
            Bitmap.new("img/button-try0.png"),
            Bitmap.new("img/button-try1.png"),
            Bitmap.new("img/button-try2.png")
          ]
        }
      end
      @button_try.opacity = 128
      @button_try.z = ZOrder::BUTTON_TRY
      @button_try.set_method(:button_down, method(:m_button_try_down))
      @button_try.set_method(:button_up, method(:m_button_try_up))
      @button_hole.each do |button|
        button.set_method(:button_down, method(:m_button_hole_down))
        button.set_method(:button_up, method(:m_button_hole_up))
        button.z = ZOrder::HOLE
      end
      bmp_item = Bitmap.new(576, 16)
      bmp_item.blt(0, 0, Bitmap.new("img/numbers.png"), Rect.new(0, 0, 160, 16))
      bmp_item.blt(160, 0, Bitmap.new("img/alphabets.png"), Rect.new(0, 0, 416, 16))
      @sprite_item = Array.new(@item_size) {Sprite.new}
      @sprite_item.each_index do |i|
        @sprite_item[i].bitmap = bmp_item
        @sprite_item[i].x = 2 + get_first_item_pos_x(i)
        @sprite_item[i].y = 2 + get_first_item_pos_y(i)
        if @item_size == 26
          @sprite_item[i].src_rect.x = 160 + i * 16
        else
          @sprite_item[i].src_rect.x = i * 16
        end
        @sprite_item[i].src_rect.width = 16
        @sprite_item[i].z = ZOrder::ITEM
      end
      bmp_circle = Bitmap.new("img/circle20.png")
      @button_item_circle = Array.new(@item_size) do |i|
        Button.new(20, 20) do
          {
            :x => get_first_item_pos_x(i),
            :y => get_first_item_pos_y(i),
            :bitmap => [bmp_circle],
            :index => i
          }
        end
      end
      @button_item_circle.each do |button|
        button.set_method(:button_down, method(:m_button_item_down))
        button.set_method(:button_up, method(:m_button_item_up))
        button.z = ZOrder::ITEM_CIRCLE
        button.opacity = 64
      end
      @button_previous = Button.new(32, 32) do
        {
          :x => 320 - 40,
          :y => 8,
          :bitmap =>
          [
            Bitmap.new("img/button-previous0.png"),
            Bitmap.new("img/button-previous1.png"),
            Bitmap.new("img/button-previous2.png")
          ]
        }
      end
      @button_previous.set_method(:button_down, method(:m_button_previous_down))
      @button_previous.set_method(:button_up, method(:m_button_previous_up))
      @button_previous.opacity = 0
      @viewport_list = Viewport.new(32, 160, 256, 144)
      @viewport_list.z = ZOrder::LIST_CONTENTS
      @sprite_list_background = Sprite.new
      @sprite_list_background.x = @viewport_list.rect.x
      @sprite_list_background.y = @viewport_list.rect.y
      @sprite_list_background.z = ZOrder::LIST_BACKGROUND
      @sprite_list_background.bitmap = Bitmap.new(@viewport_list.rect.width, @viewport_list.rect.height)
      @sprite_list_background.bitmap.fill_rect(@sprite_list_background.src_rect, Color.new(0, 0, 0, 128))
      @sprite_list = Sprite.new(@viewport_list)
      @sprite_list.bitmap = Bitmap.new(@viewport_list.rect.width, Config::LIST_ITEM_SIZE * Config::LIST_HEIGHT_PER_LINE)
      @sprite_list.bitmap.font.size = 16
      @bitmap_bull = Bitmap.new("img/bull.png")
      @bitmap_cow = Bitmap.new("img/cow.png")
      @queue_log = Array.new
      @count = 0
    end

    def dispose

    end

    def update_phase
      case @phase
      when 0
        @sprite_black.opacity -= 10
        @sprite_black.opacity = 0 if @sprite_black.opacity < 0
        return if @sprite_black.opacity != 0
        @phase = -1
      end
    end

    def update_show_try_button
      @button_try.y -= ((@button_try.y.abs - Config::BUTTON_TRY_SHOWED_Y) * 0.1).ceil
      @button_try.y = Config::BUTTON_TRY_SHOWED_Y if @button_try.y < Config::BUTTON_TRY_SHOWED_Y
    end

    def update_hide_try_button
      @button_try.y += ((Config::BUTTON_TRY_HIDDEN_Y - @button_try.y.abs) * 0.15).ceil
      @button_try.y = Config::BUTTON_TRY_HIDDEN_Y if @button_try.y > Config::BUTTON_TRY_HIDDEN_Y
    end

    def m_button_try_down
      
    end

    def m_button_try_up
      if @my_answer.include?(nil)
        return
      end
      @count += 1
      push_log
    end

    def m_button_previous_down

    end

    def m_button_previous_up
      
    end

    def item_follow_cursor(i)
      @sprite_item[i].x = InputManager.pos.x - 8
      @sprite_item[i].y = InputManager.pos.y - 8
    end

    def get_first_item_pos_x(index)
      return 32 + (index % 10) * 26
    end

    def get_first_item_pos_y(index)
      return 68 + (index / 10) * 22
    end

    def get_inhole_item_pos_x(index)
      sx = (320 - @digit * 34) / 2 + 8
      return sx + index * 34
    end

    def get_inhole_item_pos_y(index)
      return 40
    end

    def get_bull_cow_size
      bull = cow = 0
      for i in 0...@digit
        if @real_answer[i] == @my_answer[i]
          bull += 1
        else
          if @real_answer.include?(@my_answer[i])
            cow += 1
          end
        end
      end
      return bull, cow
    end

    def convert_index_to_ascii(index)
      case @item_size
      when 10
        return (index + ?0).chr
      when 26
        return (index + ?A).chr
      when 36
        return (index + ?0).chr if index < 10
        return (index + ?A - 10).chr
      end
    end

    def convert_ascii_to_index(ascii)
      case @item_size
      when 10
        return ascii[0] - '0'[0]
      when 26
        return ascii[0] - 'A'[0]
      when 36
        return ascii[0] - '0'[0] if ascii[0] >= '0'[0] && ascii[0] <= '9'[0]
        return ascii[0] - 'A'[0] + 10
      end
    end

    def draw_log(y, count, answer, bull, cow)
      @sprite_list.bitmap.font.bold = false
      @sprite_list.bitmap.draw_text(4, y, 36, Config::LIST_HEIGHT_PER_LINE, sprintf("%03d", count))
      @sprite_list.bitmap.font.bold = true
      @sprite_list.bitmap.draw_text(40, y, 70, Config::LIST_HEIGHT_PER_LINE, answer.join("."))
      x = @viewport_list.rect.width
      for i in 0...cow
        x -= Config::LIST_HEIGHT_PER_LINE
        @sprite_list.bitmap.blt(x, y, @bitmap_cow, Rect.new(0, 0, 24, 24))
      end
      for i in 0...bull
        x -= Config::LIST_HEIGHT_PER_LINE
        @sprite_list.bitmap.blt(x, y, @bitmap_bull, Rect.new(0, 0, 24, 24))
      end
    end

    def draw_log_list
      y = (@queue_log.size - 1) * Config::LIST_HEIGHT_PER_LINE
      draw_log(y, *@queue_log.last)
    end

    def draw_full_log_list
      @sprite_list.bitmap.clear
      y = 0
      @queue_log.each do |log|
        draw_log(y, *log)
        y += Config::LIST_HEIGHT_PER_LINE
      end
    end

    def push_log
      bull, cow = get_bull_cow_size
      @queue_log.push([@count, @my_answer.clone, bull, cow])
      # draw
      if @queue_log.size > Config::LIST_ITEM_SIZE
        @queue_log.shift # pop
        draw_full_log_list
      else
        draw_log_list
      end
      # scroll
      count_item_showed = @viewport_list.rect.height / Config::LIST_HEIGHT_PER_LINE.to_f
      if @queue_log.size >= count_item_showed.ceil
        @viewport_list.oy = @queue_log.size * Config::LIST_HEIGHT_PER_LINE - @viewport_list.rect.height
      end
    end

    def generate_answer(digit, range)
      return range if digit == 2
      answer = Array.new
      while answer.size < digit
        idx = rand(range.size)
        answer.push(range[idx])
        range.delete_at(idx)
      end
      return answer
    end
  end
end

if $NEKO_RUBY.nil?
  require "scene/game-windows"
else
  require "scene/game-nekoplayer"
end