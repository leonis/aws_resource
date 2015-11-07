require 'spec_helper'

RSpec.describe AwsResource::Ec2::Vpc do
  subject(:model) { AwsResource::Ec2::Vpc }

  it { expect(model.included_modules).to include(AwsResource::Concerns::Enumerable) }

  describe '.find_by_id' do
    subject { model.find_by_id(vpc_id) }

    context 'when vpc_id is invalid' do
      let(:vpc_id) { 'invalid_id' }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidVpcIDNotFound) }
    end

    context 'when vpc_id is valid format, but no such vpc exists.' do
      let(:vpc_id) { 'vpc-123456' }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidVpcIDNotFound) }
    end

    context 'when vpc_id is valid' do
      if ENV['VPC_ID']
        let(:vpc_id) { ENV['VPC_ID'] }
        it 'return AwsResource::Ec2::Vpc model' do
          expect(subject).to be_an_instance_of(AwsResource::Ec2::Vpc)
          expect(subject.vpc_id).to eq(vpc_id)
        end
      else
        skip 'This spec require VPC_ID environment variable.'
      end
    end
  end

  describe '.find_by_ids' do
    subject { model.find_by_ids(vpc_ids) }

    context 'when vpc_ids is empty' do
      let(:vpc_ids) { [] }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidVpcIDNotFound) }
    end

    context 'when vpc_ids contains invalid vpc_id' do
      let(:vpc_ids) { ['invalid_id'] }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidVpcIDNotFound) }
    end

    context 'when vpc_ids contains valid vpc_id' do
      if ENV['VPC_ID']
        let(:vpc_ids) { [ENV['VPC_ID']] }
        it 'return Array of AwsResource::Ec2::Vpc' do
          expect(subject).to be_an_instance_of(Array)
          expect(subject.size).to eq(1)
          expect(subject.map(&:vpc_id)).to eq(vpc_ids)
        end
      else
        skip 'This spec require VPC_ID environment variable.'
      end
    end
  end

  describe '.find_by_tags' do
    subject { model.find_by_tags(tags) }

    context 'when tags is empty' do
      let(:tags) { {} }
      it { expect { subject }.to raise_error(Aws::EC2::Errors::InvalidParameterValue) }
    end

    context 'when tags contains non-exists tags' do
      let(:tags) { { unknownkey: 'not found' } }
      it { expect(subject).to be_empty }
    end

    context 'when tags contains valid tag' do
      if ENV['VPC_TAG']
        let(:tags) { parse_tag(ENV['VPC_TAG']) }
        it 'return Array of AwsResource::Ec2::Vpc instance' do
          expect(subject).to be_an_instance_of(Array)
          expect(subject.size).to be > 0

          vpc = subject.first
          tags.each do |key, value|
            expect(
              vpc.tags.find { |t| t.key == key && t.value == value }
            ).not_to be_nil
          end
        end
      else
        skip 'This spec require VPC_TAG environment variable in format of "key=value"'
      end
    end
  end
end
