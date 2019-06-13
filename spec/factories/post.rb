FactoryBot.define do
  factory :post do

    trait :void do
      status { 'void' }
    end

    trait :filled do
      sequence(:title) { |n| "10 secrets to creating engaging content #{n}" }
      tags { ['foo','bar'] }
      body { 
        "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus dictum pulvinar finibus.
        Nam enim mauris, semper vitae dignissim id, gravida nec sem. Phasellus dapibus dictum nibh
        eu faucibus. Nulla pharetra augue sit amet nibh rutrum vulputate. Suspendisse lorem urna,
        pharetra pretium cursus vel, varius vel augue. Maecenas vitae tellus a magna pellentesque
        tempus. Suspendisse tristique, metus a sollicitudin luctus, neque velit scelerisque quam,
        sit amet consectetur risus enim ut mauris. Nunc ultricies metus non sapien egestas
        aliquam.
        </p>
        <p>
        Pellentesque vestibulum lacinia mauris, eget mattis orci laoreet sit amet. Suspendisse finibus
        dui mi, in venenatis ante facilisis eget. Duis fringilla pharetra vulputate. Cras sit amet
        felis vestibulum, eleifend enim a, tincidunt lectus. Mauris ultricies augue metus, id
        ullamcorper justo cursus sed. Pellentesque ornare maximus risus, non placerat justo posuere
        sit amet. Integer consequat eget neque quis facilisis. Fusce efficitur id ante vel
        consectetur. In ut nibh in mi porttitor hendrerit vitae non leo. Vestibulum vel diam lacinia
        turpis convallis ultricies. Aliquam sodales sapien tincidunt, aliquet orci vel, venenatis est.
        Fusce et mattis tellus. Etiam pretium libero quis accumsan maximus. Phasellus at ex ac ipsum
        interdum auctor. Fusce luctus cursus orci, feugiat iaculis purus condimentum eu.
        </p>" 
      }
    end

    trait :published do
      status             { 'published' }
      published_at       { Time.now }
      content_changed_at { Time.now }
    end

    trait :disabled do
      status              { 'disabled' }
      published_at        { Time.now } 
      content_changed_at  { Time.now }
    end

    trait :draft do
      status { 'draft' }
    end

    admin_account

    factory :filled_post,     traits: [:filled]
    factory :void_post,       traits: [:void]
    factory :draft_post,      traits: [:filled, :draft]
    factory :published_post,  traits: [:filled, :published]
    factory :disabled_post,   traits: [:filled, :disabled]

  end
end

