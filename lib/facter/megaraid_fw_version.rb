require 'semver'

Facter.add(:megaraid_fw_version) do
  megacli = Facter.value(:megacli)
  version_commands = ["#{megacli} -Version -Ctrl -aALL -NoLog",
                      "#{megacli} -AdpAllInfo -aALL -NoLog"]

  setcode do
    next if megacli.nil?

    version = nil
    version_commands.each do |cmd|
      output = Facter::Util::Resolution.exec(cmd)
      next if output.nil?
      m = output.match(/FW Version\s*:\s*([\d\.\-]+)\s*$/)
      next if m.nil?
      next unless m.size == 2
      version = m[1]
      break
    end
    version
  end
end
