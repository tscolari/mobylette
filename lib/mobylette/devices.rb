require 'singleton'
module Mobylette
  class Devices
    include Singleton

    def initialize
      @devices = {
        android:  /android/i,
        android2: /android\s+2\./i,
        android3: /android\s+3\./i,
        android4: /android\s+4\./i,
        iphone:   /iphone/i,
        ipad:     /ipad/i,
        ios:      /iphone|ipad/i,
        ios3:     /(iphone|ipad)\s+os\s+3_/,
        ios4:     /(iphone|ipad)\s+os\s+4_/,
        ios5:     /(iphone|ipad)\s+os\s+5_/,
        ios6:     /(iphone|ipad)\s+os\s+6_/
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
