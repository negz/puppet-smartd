Facter.add(:megaraid_product_name) do
  megacli = Facter.value(:megacli)
  product_name_commands = ["#{megacli} -Version -Ctrl -aALL -NoLog",
                           "#{megacli} -AdpAllInfo -aALL -NoLog"]

  setcode do
    next if megacli.nil?

    product_name = nil
    product_name_commands.each do |pnc|
      output = Facter::Util::Resolution.exec(pnc)
      next if output.nil?
      m = output.match(/Product Name\s*:\s*(.+)\s*$/)
      next if m.nil?
      next unless m.size == 2
      product_name = m[1]
      break
    end
    product_name
  end
end
