require 'helper'

class TestVersionBumper < MiniTest::Unit::TestCase
  def test_that_it_should_represent_correctly_test
    v = Bumper::Version.new('0.0.0.0')
    assert_equal '0.0.0.0', v.to_s
  end

  def test_version_without_build
    v = Bumper::Version.new('0.0.0')
    assert_nil v.build
    assert_equal '0.0.0', v.to_s
  end
  
  def test_that_it_should_have_correct_properties_test
    v = Bumper::Version.new('0.0.0.0')
    assert_equal 0, v.major
    assert_equal 0, v.minor
    assert_equal 0, v.revision
    assert_equal '0', v.build
  end

  def test_that_it_should_bump_versions
    v = Bumper::Version.new('0.0.0.0')
    assert_equal '1', v.bump_build
    assert_equal 1, v.bump_revision
    assert_equal 1, v.bump_minor
    assert_equal 1, v.bump_major
    assert_equal '1.0.0.0', v.to_s
  end

  def test_that_it_should_bump_versions_alt
    v = Bumper::Version.new('0.0.0.0')
    assert_equal 1, v.bump_major
    assert_equal 1, v.bump_minor
    assert_equal 1, v.bump_revision
    assert_equal '1', v.bump_build
    assert_equal '1.1.1.1', v.to_s
  end
  
  def test_that_when_bumping_reset_smaller_versions
    v = Bumper::Version.new('1.1.1.1')
    assert_equal 2, v.bump_major
    assert_equal 0, v.minor
    assert_equal 0, v.revision
    assert_equal '0', v.build
    assert_equal '2.0.0.0', v.to_s
  end
end
