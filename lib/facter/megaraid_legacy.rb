require 'semver'

Facter.add(:megaraid_legacy) do
  megacli = Facter.value(:megacli)
  megacli_version = Facter.value(:megacli_version)

  setcode do
    next if megacli.nil?
    next if megacli_version.nil?

    actual_version = SemVer.new(megacli_version)
    modern_version = SemVer.new('8.02.16')

    actual_version < modern_version

  end
end
