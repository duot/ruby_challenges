require 'pry'
<<NOTES
  InvalidCodonError is declared inside the class
  but defined in global using `::`

  `Hash#fetch` will raise `KeyError` if no key found.

  PROTEINS = {
    'AUG'=>'Methionine',
    'UUU'=>'Phenylalanine',
    'UUC'=>'Phenylalanine',
    'UUA'=>'Leucine',
    'UUG'=>'Leucine',
    'UCU'=>'Serine',
    'UCC'=>'Serine',
    'UCA'=>'Serine',
    'UCG'=>'Serine',
    'UAU'=>'Tyrosine',
    'UAC'=>'Tyrosine',
    'UGU'=>'Cysteine',
    'UGC'=>'Cysteine',
    'UGG'=>'Tryptophan',
    'UAA'=>'STOP',
    'UAG'=>'STOP',
    'UGA'=>'STOP'
  }.freeze
NOTES

class Translation
  class ::InvalidCodonError < RuntimeError; end


  PROTEINS = {
    "AUG"=>"Methionine", "UUU"=>"Phenylalanine", "UUC"=>"Phenylalanine",
    "UUA"=>"Leucine", "UUG"=>"Leucine", "UCU"=>"Serine", "UCC"=>"Serine",
    "UCA"=>"Serine", "UCG"=>"Serine", "UAU"=>"Tyrosine", "UAC"=>"Tyrosine",
    "UGU"=>"Cysteine", "UGC"=>"Cysteine", "UGG"=>"Tryptophan", "UAA"=>"STOP",
    "UAG"=>"STOP", "UGA"=>"STOP"
  }.freeze

  def self.of_codon(codon)
    PROTEINS.fetch(codon) { raise InvalidCodonError }
  end

  def self.of_rna(strand)
    codons = strand.chars.each_slice(3).map(&:join)
    
    codons.each_with_object([]) do |c, proteins|
      protein = of_codon c
      break proteins if protein == 'STOP'
      proteins << protein
    end
  end
end
