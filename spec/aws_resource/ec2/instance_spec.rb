require 'spec_helper'

RSpec.describe AwsResource::Ec2::Instance do
  subject(:model) { AwsResource::Ec2::Instance }

  it { expect(model.included_modules).to include(AwsResource::Concerns::Enumerable) }

  describe '.find_by_id' do
    subject { model.find_by_id(instance_id) }

    context 'when instance_id is invalid' do
      let(:instance_id) { 'invalid_id' }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidInstanceIDMalformed) }
    end

    context 'when instance_id is valid format,  but no such instance exists.' do
      let(:instance_id) { 'i-12345678' }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidInstanceIDNotFound) }
    end

    context 'when valid instance_id' do
      if ENV['EC2_INSTANCE_ID']
        let(:instance_id) { ENV['EC2_INSTANCE_ID'] }
        it 'return AwsResource::Ec2::Instance model' do
          expect(subject).to be_an_instance_of(AwsResource::Ec2::Instance)
          expect(subject.instance_id).to eq(instance_id)
        end
      else
        skip 'This spec require EC2_INSTANCE_ID environment variable.'
      end
    end
  end

  describe '.find_by_ids' do
    subject { model.find_by_ids(instance_ids) }

    context 'when instance_ids is empty' do
      let(:instance_ids) { [] }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::MissingParameter) }
    end

    context 'when instance_ids contains invalid instance_id' do
      let(:instance_ids) { ['invalid_id'] }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidInstanceIDMalformed) }
    end

    context 'when instance_ids contains valid instance_id, but no such instance exists.' do
      let(:instance_ids) { ['i-12345678'] }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidInstanceIDNotFound) }
    end

    context 'when instance_ids contains valid instance_id' do
      if ENV['EC2_INSTANCE_ID']
        let(:instance_ids) { [ENV['EC2_INSTANCE_ID']] }
        it 'return Array of AwsResource::Ec2::Instance' do
          expect(subject).to be_an_instance_of(Array)
          expect(subject.size).to eq(1)
          expect(subject.map(&:instance_id)).to eq(instance_ids)
        end
      else
        skip 'This spec require EC2_INSTANCE_ID environment variable.'
      end
    end
  end

  describe '.find_by_tags' do
    subject { model.find_by_tags(tags) }

    context 'when tags is empty' do
      let(:tags) { {} }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidParameterValue) }
    end

    context 'when tags contain non-exists tags' do
      let(:tags) { { unknownkey: 'not found' } }
      it { expect(subject).to be_empty }
    end

    context 'when tags contain valid tag' do
      if ENV['EC2_INSTANCE_TAG']
        let(:tags) { parse_tag(ENV['EC2_INSTANCE_TAG']) }
        it 'return Array of AwsResource::Ec2::Instance' do
          expect(subject).to be_an_instance_of(Array)
          expect(subject.size).to be > 0

          instance = subject.first
          tags.each do |key, value|
            expect(
              instance.tags.find { |t| t.key == key && t.value == value }
            ).not_to be_nil
          end
        end
      else
        skip 'This spec requre EC2_INSTANCE_TAG environment variable in format of "key=value".'
      end
    end
  end
end
