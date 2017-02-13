require 'spec_helper'

RSpec.describe Voter, type: :model do

  # Create Zone and Zone coordinator
  before :each do
    @zone = Zone.create!({
      name: 'Test Zone'
    })

    @super_voter = Voter.create!({
      address:   'Test Voter Address',
      electoral_number: 'ELECTORALNUMBER123',
      full_name: 'Test Voter',
      imported: true,
      role: 1,
      section: 'Test Voter Section'
    })
  end

  it 'creates the voter from importation' do
    @imported_voter = Voter.create!({
      full_name: 'Test Voter',
      address:   'Test Voter Address',
      electoral_number: 'ELECTORALNUMBER124',
      section: 'Test Voter Section',
      imported: true
    })

    expect(Voter.where(id: @imported_voter.id).count).to eq(1);
  end

  it 'creates the voter as zone coordinator from app' do
    @zone_coordinator_voter = Voter.create!({
      address:   'Test Voter Address',
      areas_ids: "['#{ @zone.id }']",
      electoral_number: 'ELECTORALNUMBER125',
      email: 'test@voter.com',
      full_name: 'Test Voter',
      imported: false,
      latitude: '123',
      longitude: '987',
      password: '12345678',
      phone_number: '555444333',
      role: 1,
      section: 'Test Voter Section',
      social_network: 'Twitter',
      user_id: @super_voter.id
    })

    expect(Voter.where(id: @zone_coordinator_voter.id).count).to eq(1);
  end

end
