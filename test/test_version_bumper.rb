require 'helper'

class TestVersionBumper < MiniTest::Test
  def test_version_new
    assert_equal Bumper::Version.new.to_s, '0.0.0.0'
    assert_equal Bumper::Version.new('0.0.0-alpha.0').to_s, '0.0.0-alpha.0'
    assert_equal Bumper::Version.new('0.0.0-alpha').to_s, '0.0.0-alpha'
    assert_equal Bumper::Version.new('0.0.0').to_s, '0.0.0'
    assert_equal Bumper::Version.new('0.0').to_s, '0.0'
  end
  
  def test_that_it_should_represent_correctly_test
    v = Bumper::Version.new
    assert_equal '0.0.0.0', v.to_s
    assert_equal 0, v.major
    assert_equal 0, v.minor
    assert_equal 0, v.patch
    assert_nil v.patch_tag
    assert_equal '0', v.build
  end
  
  def test_version_without_build
    v = Bumper::Version.new('0.0.0')
    assert_equal 0, v.major
    assert_equal 0, v.minor
    assert_equal 0, v.patch
    assert_nil v.patch_tag
    assert_nil v.build
    assert_equal '0.0.0', v.to_s

    v = Bumper::Version.new('0.0.0-alpha')
    assert_equal 0, v.major
    assert_equal 0, v.minor
    assert_equal 0, v.patch
    assert_equal 'alpha', v.patch_tag
    assert_nil v.build
    assert_equal '0.0.0-alpha', v.to_s
  end
  
  def test_version_without_patch
    v = Bumper::Version.new('0.0')
    assert_equal 0, v.major
    assert_equal 0, v.minor
    assert_nil v.patch
    assert_nil v.build
    assert_equal '0.0', v.to_s
  end
  
  
  # $ rake bump:init
  # version: 0.0.0.0
  # $ rake bump:build
  # version: 0.0.0.1
  # $ rake bump:patch
  # version: 0.0.1.0
  # $ rake bump:minor
  # version: 0.1.0.0
  # $ rake bump:major
  # version: 1.0.0.0
  def test_that_it_should_bump_versions
    v = Bumper::Version.new
    assert_equal '1', v.bump_build
    assert_equal '0.0.0.1', v.to_s
    assert_equal 1, v.bump_patch
    assert_equal '0.0.1.0', v.to_s
    assert_equal 1, v.bump_minor
    assert_equal '0.1.0.0', v.to_s
    assert_equal 1, v.bump_major
    assert_equal '1.0.0.0', v.to_s
  end
  
  def test_that_it_should_bump_versions_alt
    v = Bumper::Version.new
    assert_equal 1, v.bump_major
    assert_equal '1.0.0.0', v.to_s
    assert_equal 1, v.bump_minor
    assert_equal '1.1.0.0', v.to_s
    assert_equal 1, v.bump_patch
    assert_equal '1.1.1.0', v.to_s
    assert_equal '1', v.bump_build
    assert_equal '1.1.1.1', v.to_s
  end
  
  def test_that_when_bumping_reset_smaller_versions
    v = Bumper::Version.new('1.1.1.1')
    assert_equal 2, v.bump_major
    assert_equal 0, v.minor
    assert_equal 0, v.patch
    assert_equal '0', v.build
    assert_equal '2.0.0.0', v.to_s
  end
  
  def test_that_bumping_major_without_build_does_not_add_build
    v = Bumper::Version.new('0.0.0')
    v.bump_major
    assert_equal '1.0.0', v.to_s
  end
  
  # $ rake bump:init
  # version: 0.0.0.0
  # $ rake bump:minor
  # version: 0.1.0.0
  # $ rake bump:patch[beta]
  # version: 0.1.1-beta.0
  # $ rake bump:patch[beta]
  # version: 0.1.1-beta2.0
  # $ rake bump:build
  # version: 0.1.1-beta2.1
  # $ rake bump:patch[rc]
  # version: 0.1.1-rc.0
  # $ rake bump:patch[rc]
  # version: 0.1.1-rc2.0
  # $ rake bump:patch
  # version: 0.1.1.0
  # $ rake bump:patch
  # version: 0.1.2.0
  # $ rake bump:minor
  # version: 0.2.0.0
  # $ rake bump:patch[alpha]
  # version: 0.2.1-alpha.0
  def test_that_bumping_with_prereleases
    v = Bumper::Version.new
    assert_equal '0.0.0.0', v.to_s
    assert_equal 1, v.bump_minor
    assert_equal '0.1.0.0', v.to_s
    assert_equal 'beta', v.bump_patch_tag('beta')
    assert_equal '0.1.1-beta.0', v.to_s
    assert_equal 'beta2', v.bump_patch_tag('beta')
    assert_equal '0.1.1-beta2.0', v.to_s
    assert_equal '1', v.bump_build
    assert_equal '0.1.1-beta2.1', v.to_s
    assert_equal 'rc', v.bump_patch_tag('rc') # replaces tag
    assert_equal '0.1.1-rc.0', v.to_s
    assert_equal 'rc2', v.bump_patch_tag('rc')
    assert_equal '0.1.1-rc2.0', v.to_s
    assert_equal 1, v.bump_patch # drops tag
    assert_equal '0.1.1.0', v.to_s
    assert_equal 2, v.bump_patch
    assert_equal '0.1.2.0', v.to_s
    assert_equal 2, v.bump_minor
    assert_equal '0.2.0.0', v.to_s
    assert_equal 'alpha', v.bump_patch_tag('alpha')
    assert_equal '0.2.1-alpha.0', v.to_s
  end
  
  def test_patch_tag_messy
    v = Bumper::Version.new('0.0.0-alpha.0')
    assert_equal 'alpha', v.patch_tag
    v.patch_tag = nil
    puts v.patch_tag
    assert_equal nil, v.patch_tag
  end
  
  def test_invalid_versions
    assert_raises(ArgumentError) {Bumper::Version.new('0.0.alpha.0')}
  end
  
  def test_backward_compat
    v = Bumper::Version.new('0.0.0.0')
    assert_equal '0.0.0.0', v.to_s
    v = Bumper::Version.new
    assert_equal 1, v.bump_revision
    assert_equal 1, v.revision
    assert_equal v.patch, v.revision
    assert_equal '0.0.1.0', v.to_s
  end
end
