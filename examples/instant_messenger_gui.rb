#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

puts 'A GUI instant messenger demo which can also talk to the command-line version! (Requires the "wxruby" gem.)'
# Load up the library!
require 'journeta'
include Journeta
include Journeta::Common

require 'rubygems'


# Use UTF-8.
$KCODE = 'u'

# Library to get character lengths (as opposed to byte lengths) from Ruby strings.
require 'jcode'

# Load the wxruby GUI library.
require 'wx'

class JournetaGUIHandler
  
  def initialize(control)
    @control = control
  end
  
  def call(message)
    if message.class == BasicMessage
      text = @control.get_value
      text.chop!
      text += "\n#{message.name.chop}: #{message.text}"
      @control.set_value text
    else
      putsd("Unsupported message type received from peer. (#{message})")
    end
  end
end


class PeerTextControl < Wx::TextCtrl
  
  DEFAULT_TEXT = "(joined chat at #{Time.now})\n\n"
  
  def initialize(parent, text = DEFAULT_TEXT)
    super(parent, -1, text, 
          Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, Wx::TE_MULTILINE)
  end
  
end

# A read-only text ctrl useful for displaying output
class MessageTextControl < Wx::TextCtrl
  STYLE = Wx::TE_READONLY|Wx::TE_MULTILINE
  def initialize(parent)
    super(parent, -1, '', Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, STYLE)
  end
end

class IConvFrame < Wx::Frame
  
  @name = 'anonymous'
  
  # Ruby stdlib for converting strings between encodings
  begin
    require 'iconv'
    ICONV_LOADED = 1
  rescue LoadError
  end
  
  
  
  def initialize(title, pos, size)
    super(nil, -1, title, pos, size)
    panel = Wx::Panel.new(self)
    
    # TODO Ask user for name.
    dialog = Wx::TextEntryDialog.new(self,  "What's your name?", 
                    "Please enter text", 
                    "anonymous", 
    Wx::OK , 
    Wx::DEFAULT_POSITION)
    dialog.show_modal
    @name = dialog.get_value
    
    sizer = Wx::BoxSizer.new(Wx::VERTICAL)
    
    # The text input and display
    @peer_control = PeerTextControl.new(panel)
    sizer.add(@peer_control, 3, Wx::GROW|Wx::ALL, 2)
    @peer_control.set_editable(false)
    # TODO set background color so it's obviously read-only.
    #    @peer_control.set_background_colour('888888')
    
    @message_control = MessageTextControl.new(panel)
    @message_control.set_editable(true)
    sizer.add(@message_control, 1, Wx::GROW|Wx::ALL, 2)
    
    # The button to show what's selected
    button = Wx::Button.new(panel, -1, 'Send')
    sizer.add(button, 0, Wx::ADJUST_MINSIZE|Wx::ALL, 2 )
    evt_button(button.get_id) { | e | on_click(e) }
    
    panel.set_sizer_and_fit( sizer )
    
    peer_port = (2048 + rand( 2 ** 8))
    @journeta = Journeta::JournetaEngine.new(:peer_port => peer_port, :peer_handler => JournetaGUIHandler.new(@peer_control), :groups => ['im_example'])    
    @journeta.start
  end
  
  
  def construct_menus()
    menu_bar = Wx::MenuBar.new()
    
    menu_file = Wx::Menu.new()
    menu_file.append(Wx::ID_EXIT, "E&xit\tAlt-X", "Quit this program")
    evt_menu(Wx::ID_EXIT) { on_quit() }
    menu_bar.append(menu_file, "&File")
    if self.class.const_defined?(:ICONV_LOADED)
      construct_import_export_menus(menu_bar)
    end
    
    menu_help = Wx::Menu.new()
    menu_help.append(Wx::ID_ABOUT, "&About...\tF1", "Show about dialog")
    evt_menu(Wx::ID_ABOUT) { on_about() }
    menu_bar.append(menu_help, "&Help")
    
    set_menu_bar(menu_bar)
  end
  
  def on_click(e)
    text = @message_control.get_value
    msg = BasicMessage.new
    msg.name = @name
    msg.text = text
    @journeta.send_to_known_peers(msg)
    @message_control.set_value('')
    @peer_control.set_value "#{@peer_control.get_value}\n#{@name}: #{text}"
  end
  
  def on_quit()
    @journeta.stop
    close(TRUE)
  end
  
  def on_about()
    msg =  "A GUI demo. Wx version #{Wx::VERSION_STRING}"
    Wx::message_box(msg, "About Minimal", Wx::OK|Wx::ICON_INFORMATION, self)
  end
end


class InstantMessengerApplication < Wx::App
  
  def on_init()    
    frame = IConvFrame.new("Journeta Instant Messenger",
    Wx::Point.new(50, 50),
    Wx::Size.new(450, 450) )
    
    frame.show(true)
  end
end

InstantMessengerApplication.new().main_loop()
