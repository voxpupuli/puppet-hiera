# This will validate hiera 5 hierarchy array hash
type Hiera::Hiera5_hierarchy =  Array[Struct[{
                                  name            => String,
                                  path            => Optional[String],
                                  paths           => Optional[Array[String]],
                                  mapped_paths    => Optional[Array[String,3,3]],
                                  glob            => Optional[String],
                                  globs           => Optional[Array[String]],
                                  uri             => Optional[String],
                                  uris            => Optional[Array[String]],
                                  data_hash       => Optional[String],
                                  lookup_key      => Optional[String],
                                  data_dig        => Optional[String],
                                  datadir         => Optional[String],
                                  hiera3_backend  => Optional[String],
                                  options         => Optional[Hash],
                                }]]
