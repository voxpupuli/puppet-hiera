# This will validate hiera 5 'defaults' hash
type Hiera::Hiera5_defaults = Struct[{
                                datadir         =>  Optional[String],
                                data_hash       =>  Enum['yaml_data', 'json_data', 'hocon_data'],
                                lookup_key      =>  Optional[String],
                                data_dig        =>  Optional[String],
                                hiera3_backend  =>  Optional[String]
                              }]
