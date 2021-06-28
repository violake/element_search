require 'data_search/organization_search'
require 'data_search/user_search'
require 'data_search/ticket_search'
require 'rspec/json_expectations'

describe DataSearch::OrganizationSearch do
  describe 'search organization by _id' do
    subject(:organization_by_id) do
      DataSearch::OrganizationSearch.find_elements_include_association(:_id, id)[0]
    end

    context 'valid id value' do
      let(:id) { :'101' }

      it 'should get the organization' do
        expect(organization_by_id).to include_json(
          {
            _id: 101,
            url: 'http://initech.zendesk.com/api/v2/organizations/101.json',
            external_id: '9270ed79-35eb-4a38-a46f-35725197ea8d',
            name: 'Enthaze',
            domain_names: [
              'kage.com',
              'ecratic.com',
              'endipin.com',
              'zentix.com'
            ],
            created_at: '2016-05-21T11:10:28 -10:00',
            details: 'MegaCorp',
            shared_tickets: false,
            tags: %w[
              Fulton
              West
              Rodriguez
              Farley
            ]
          }
        )
      end

      context 'associated users' do
        it 'should have users' do
          expect(organization_by_id[:users].count).to eq 4
        end

        it 'each user should have all attrs' do
          expect(organization_by_id[:users][0]).to eq(
            {
              _id: 5,
              active: true,
              alias: 'Mr Ola',
              created_at: '2016-06-12T08:49:19 -10:00',
              email: 'olapittman@flotonic.com',
              external_id: '29c18801-fb42-433d-8674-f37d63e637df',
              last_login_at: '2013-07-03T06:59:27 -10:00',
              locale: 'zh-CN',
              name: 'Loraine Pittman',
              organization_id: 101,
              phone: '9805-292-618',
              role: 'admin',
              shared: false,
              signature: "Don't Worry Be Happy!",
              suspended: false,
              tags: %w[Frizzleburg Forestburg Sandston Delco],
              timezone: 'Monaco',
              url: 'http://initech.zendesk.com/api/v2/users/5.json',
              verified: false
            }
          )
        end
      end

      context 'associated tickets' do
        it 'should have tickets' do
          expect(organization_by_id[:tickets].count).to eq 4
        end

        it 'each ticket should have all attrs' do
          expect(organization_by_id[:tickets][0]).to eq(
            {
              _id: 'b07a8c20-2ee5-493b-9ebf-f6321b95966e',
              assignee_id: 17,
              created_at: '2016-03-21T11:18:13 -11:00',
              description: 'Laborum exercitation officia nulla in. Consequat et commodo fugiat velit magna sunt mollit.',
              due_at: '2016-08-04T12:30:08 -10:00',
              external_id: 'ca4452fc-b24d-4e06-a752-b15ee3fc42bb',
              has_incidents: true,
              organization_id: 101,
              priority: 'low',
              status: 'hold',
              subject: 'A Drama in Portugal',
              submitter_id: 50,
              tags: ['Ohio', 'Pennsylvania', 'American Samoa', 'Northern Mariana Islands'],
              type: 'question',
              url: 'http://initech.zendesk.com/api/v2/tickets/b07a8c20-2ee5-493b-9ebf-f6321b95966e.json',
              via: 'web'
            }
          )
        end
      end
    end
  end
end
