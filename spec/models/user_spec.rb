require 'rails_helper'

RSpec.describe User do
  describe 'initialization from calnet' do
    # @todo Is this still valid since the switch from berkeleyEduOfficialEmail?
    it 'assigns the user their berkeleyEduOfficialEmail' do
      uid = 12_345
      User.from_calnet(OmniAuth::AuthHash.new({
                                                'uid' => uid,
                                                'extra' => {
                                                  'berkeleyEduOfficialEmail' => 'official@berkeley.edu'
                                                }
                                              }))

      user = User.find_by(calnet_uid: uid)
      expect(user.email).to eq 'official@berkeley.edu'
    end
  end
end
