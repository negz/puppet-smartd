Facter.add(:megaraid_fw_package_build) do
  megacli = Facter.value(:megacli)
  package_commands = ["#{megacli} -Version -Ctrl -aALL -NoLog",
                      "#{megacli} -AdpAllInfo -aALL -NoLog"]

  setcode do
    next if megacli.nil?

    package = nil
    package_commands.each do |pkg|
      output = Facter::Util::Resolution.exec(pkg)
      next if output.nil?
      m = output.match(/F[wW] Package Build\s*:\s*([\d\.\-]+)\s*$/)
      next if m.nil?
      next unless m.size == 2
      package = m[1]
      break
    end
    package
  end
end
