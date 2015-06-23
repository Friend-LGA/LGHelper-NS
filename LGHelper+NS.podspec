Pod::Spec.new do |s|

    s.name = 'LGHelper+NS'
    s.version = '1.0.0'
    s.platform = :ios, '6.0'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Friend-LGA/LGHelper-NS'
    s.author = { 'Grigory Lutkov' => 'Friend.LGA@gmail.com' }
    s.source = { :git => 'https://github.com/Friend-LGA/LGHelper-NS.git', :tag => s.version }
    s.summary = 'iOS helper extends NSArray, NSData, NSDate, NSDictionary and other NS* classes'

    s.library = 'z'

    s.requires_arc = true

    s.source_files = 'LGHelper+NS/*.{h,m}'

end
