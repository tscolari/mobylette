require 'singleton'
module Mobylette
  class Devices
    include Singleton

    def initialize
      @devices = {
        android:  %r{android}i,
        android2: %r{android\s+2\.}i,
        android3: %r{android\s+3\.}i,
        android4: %r{android\s+4\.}i,
        android_phone: %r{android.*mobile}i,
        iphone:   %r{iphone}i,
        ipad:     %r{ipad}i,
        ios:      %r{iphone|ipad}i,
        ios3:     %r{(iphone|ipad)\s+os\s+3_},
        ios4:     %r{(iphone|ipad)\s+os\s+4_},
        ios5:     %r{(iphone|ipad)\s+os\s+5_},
        ios6:     %r{(iphone|ipad)\s+os\s+6_}
      }
    end

    # Register a new device to the
    # devices list
    #
    # devices - hash defining a new device and it's regex.
    #           you may assign multiple devices here.
    #
    # Examples:
    #
    #   register(iphone: /iphone/i)
    #   register(iphone: /iphone/i, ipad: /ipad/i)
    #
    def register(devices)
      @devices.merge! devices
    end

    # Returns the regex for the device
    #
    def device(device)
      @devices[device] 
    end
  end

  def self.devices
    Devices.instance
  end
end
