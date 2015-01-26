Facter.add(:megaraid_serial) do
  megacli = Facter.value(:megacli)
  serial_commands = ["#{megacli} -Version -Ctrl -aALL -NoLog",
                     "#{megacli} -AdpAllInfo -aALL -NoLog"]

  setcode do
    next if megacli.nil?

    serial = nil
    serial_commands.each do |srl|
        output = Facter::Util::Resolution.exec(srl)
        next if output.nil?
        m = output.match(/Serial No\s*:\s*(\S+)\s*$/)
        next if m.nil?
        next unless m.size == 2
        serial = m[1]
        break
    end
    serial
  end
end
