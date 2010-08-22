class Profile
  #should always be instantiated as $profile
  
  attr_accessor :garb, :string, :segment, :segment_string
  
  def intialize(profile_entered = nil, profile_object = nil, segment = nil, segment_string = nil)
    
    @garb = profile_object      # example - $profile.garb = Garb::Profile.first('6076893')
    @string = profile_entered   # the name
    @segment = segment          # slot for segment
    @segment_string = segment_string

  end
  
  def to_s
    "#{@string}\n #{@segment}, #{@segment_string}"
  end
  
  def segment?
    if @segment != nil
      return true
    else
      return false
    end
  end
  
  def segment_string?
    if @segment_string != nil
      return true
    else
      return false
    end
  end
  
end

