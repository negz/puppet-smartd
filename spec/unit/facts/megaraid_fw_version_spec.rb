require 'spec_helper'

describe 'megaraid_fw_version', :type => :fact do
  before(:each) { Facter.clear }

  context 'megacli fact not set' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns(nil)
      Facter.fact(:megaraid_fw_version).value.should be_nil
    end
  end

  context 'megacli fact is broken' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns('foobar')
      Facter.fact(:megaraid_fw_version).value.should be_nil
    end
  end

  context 'megacli fact is working' do
    it 'should get the version string using modern binary' do
      Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
        returns(File.read(fixtures('megacli', 'version-ctrl-aall-8.07.07')))
      Facter.fact(:megaraid_fw_version).value.should == '3.340.05-2939'
    end

    it 'should get the version string using legacy binary' do
      Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
        returns(File.read(fixtures('megacli', 'invalid-input-8.00.11')))
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -AdpAllInfo -aALL -NoLog').
        returns(File.read(fixtures('megacli', 'adpallinfo-aall-8.00.11')))
      Facter.fact(:megaraid_fw_version).value.should == '2.120.14-2138'
    end
  end

end

