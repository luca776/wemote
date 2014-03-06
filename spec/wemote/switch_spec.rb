require 'spec_helper'

describe Wemote::Switch do
  describe 'class methods' do

    describe '.all' do
      it 'should have specs'
    end

    describe '.find' do
      it 'should return an instance whose name matches the argument' do
        client = Manticore::Client.new
        client.mstub('http://fakehost:1234/setup.xml',body:'<friendlyName>Test Switch</friendlyName>',code:200)
        Wemote::Switch.any_instance.stub(:client).and_return(client)
        switch = Wemote::Switch.new('fakehost','1234')
        Wemote::Switch.instance_variable_set(:@switches,[switch])
        Wemote::Switch.find('Test Switch').should == switch
      end
    end

  end

  describe 'instance methods' do
    before do
      client = Manticore::Client.new
      client.mstub('http://fakehost:1234/setup.xml',body:'<friendlyName>Test Switch</friendlyName>',code:200)
      Wemote::Switch.any_instance.stub(:client).and_return(client)
      @switch = Wemote::Switch.new('fakehost','1234')
    end

    describe '#initialize' do
      it 'should set the host and port from the arguments' do
        @switch.instance_variable_get(:@host).should == 'fakehost'
        @switch.instance_variable_get(:@port).should == '1234'
      end

      it 'should set the friendly name of the switch' do
        @switch.name.should == 'Test Switch'
      end

    end

    describe 'on!' do
      it 'should call #set_state with an argument of 1' do
        expect(@switch).to receive(:set_state).with(1)
        @switch.on!
      end
    end

    describe 'off!' do
      it 'should call #set_state with an argument of 0' do
        expect(@switch).to receive(:set_state).with(0)
        @switch.off!
      end
    end

    describe 'on?' do
      it 'should return whether the switch state is on' do
        @switch.stub(:get_state).and_return(:on)
        @switch.on?.should == true
        @switch.stub(:get_state).and_return(:off)
        @switch.on?.should == false
      end
    end

    describe 'off?' do
      it 'should return whether the switch state is off' do
        @switch.stub(:get_state).and_return(:on)
        @switch.off?.should == false
        @switch.stub(:get_state).and_return(:off)
        @switch.off?.should == true
      end
    end

    describe 'get_state' do
      it 'should return the binary state of the switch' do
        @switch.client.mstub('http://fakehost:1234/upnp/control/basicevent1',body:'<BinaryState>1</BinaryState>',code:200)
        @switch.get_state.should == :on
        @switch.client.mstub('http://fakehost:1234/upnp/control/basicevent1',body:'<BinaryState>0</BinaryState>',code:200)
        @switch.get_state.should == :off
      end
    end

    describe 'set_state' do
      it 'should set the binary state of the switch' do
        @switch.client.mstub('http://fakehost:1234/upnp/control/basicevent1',body:'Called',code:200)
        @switch.set_state(1).body.should == 'Called'
      end
    end

  end
end
