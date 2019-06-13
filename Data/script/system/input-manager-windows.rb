module SDL
    class << self
      alias_method :handle_pad_touch, :handlePadTouch
      def handlePadTouch(*args)
        dw, dh = Graphics.entity.w.to_f, Graphics.entity.h.to_f
        gw, gh = Graphics.width.to_f, Graphics.height.to_f
        r = dh / gh
        gw2 = gw * r
        ew2 = (dw - gw2) / 2
        r2 = dw / gw2
        NekoConsole.callback_touch args[0], (args[1] - ew2 / dw) * gw * r2, args[2] * gh, args[3]
        handle_pad_touch *args
      end
    end
  end