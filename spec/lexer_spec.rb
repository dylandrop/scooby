require 'spec_helper'

describe Lexer do
  let(:lexer) { described_class.new(io) }
  let(:io) { StringIO.new(content) }
  let(:content) { '' }

  describe '#get_token' do
    subject { lexer.get_token }

    context 'when content is empty' do
      it { is_expected.to eq(Tokens::EOF) }
    end

    context 'when content is blank space' do
      let(:content) { '    ' }
      
      it { is_expected.to eq(Tokens::EOF) }
    end

    context 'when it sees def' do
      let(:content) { 'def' }
      
      it { is_expected.to eq(Tokens::DEF) }

      specify do
        subject
        expect(lexer.identifier_string).to eq('def')
      end
    end

    context 'when it sees extern' do
      let(:content) { 'extern' }
      
      it { is_expected.to eq(Tokens::EXTERN) }

      specify do
        subject
        expect(lexer.identifier_string).to eq('extern')
      end
    end

    context 'when it sees an identifier' do
      let(:content) { 'blahblah' }
      
      it { is_expected.to eq(Tokens::IDENTIFIER) }

      specify do
        subject
        expect(lexer.identifier_string).to eq('blahblah')
      end
    end

    context 'when it sees a number' do
      let(:content) { '123' }
      
      it { is_expected.to eq(Tokens::NUMBER) }

      specify do
        subject
        expect(lexer.num_val).to eq(123)
      end

      context 'with decimal points' do
        let(:content) { '123.3' }

        specify do
          subject
          expect(lexer.num_val).to eq(123.3)
        end
      end
    end

    context 'with comments' do
      let(:content) { '#blahblah ' }
      
      it { is_expected.to eq(Tokens::EOF) }

      context 'with a newline' do
        let(:content) { "#blahblah \n" }

        it { is_expected.to eq(Tokens::EOF) }
      end
    end

    context 'unrecognized' do
      let(:content) { '+' }
      
      it { is_expected.to eq('+'.ord) }
    end
  end
end
