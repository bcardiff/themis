class CharlestonToAuthenticJazz < ActiveRecord::Migration
  def up
    execute "UPDATE Tracks SET Code = 'AJ_PRIN' WHERE Code = 'CH_PRIN';"
    execute "UPDATE Tracks SET Code = 'AJ_AVAN' WHERE Code = 'CH_AVAN';"
    execute "UPDATE Courses SET Code = 'AJ_PRIN_LUN' WHERE Code = 'CH_PRIN_LUN';"
    execute "UPDATE Courses SET Code = 'AJ_PRIN_MIE' WHERE Code = 'CH_PRIN_MIE';"
    execute "UPDATE Courses SET Code = 'AJ_AVAN_MIE' WHERE Code = 'CH_AVAN_MIE';"
    execute "UPDATE Courses SET Code = 'AJ_AVAN_SAB' WHERE Code = 'CH_AVAN_SAB';"
  end

  def down
    execute "UPDATE Tracks SET Code = 'CH_PRIN' WHERE Code = 'AJ_PRIN';"
    execute "UPDATE Tracks SET Code = 'CH_AVAN' WHERE Code = 'AJ_AVAN';"
    execute "UPDATE Courses SET Code = 'CH_PRIN_LUN' WHERE Code = 'AJ_PRIN_LUN';"
    execute "UPDATE Courses SET Code = 'CH_PRIN_MIE' WHERE Code = 'AJ_PRIN_MIE';"
    execute "UPDATE Courses SET Code = 'CH_AVAN_MIE' WHERE Code = 'AJ_AVAN_MIE';"
    execute "UPDATE Courses SET Code = 'CH_AVAN_SAB' WHERE Code = 'AJ_AVAN_SAB';"
  end
end
