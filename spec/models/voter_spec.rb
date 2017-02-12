require 'spec_helper'

RSpec.describe Voter, type: :model do

  subject! {
    @imported_voter = Voter.create!({
      full_name: 'Test Voter',
      address:   'Test Voter Address',
      electoral_number: 'ELECTORALNUMBER123',
      section: 'Test Voter Section'
    })
  }

  it 'creates the voter from importation' do
    Voter.create!({
      full_name: 'Test Voter',
      address:   'Test Voter Address',
      electoral_number: 'ELECTORALNUMBER123',
      section: 'Test Voter Section',
      imported: true
    })

    puts '====== Voter'
    puts Voter.all
    expect(Voter.all).to eq(1);
  end

end
