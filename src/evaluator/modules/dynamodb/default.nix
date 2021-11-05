{ makeDynamoDb
, __toModuleOutputs__
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: args: {
    name = "/dynamoDb/${name}";
    value = makeDynamoDb {
      inherit name;
      inherit (args) host;
      inherit (args) port;
      dbData = builtins.map (rel: "." + rel) args.dbData;
      dbInfra = "." + args.dbInfra;
    };
  };
in
{
  options = {
    dynamoDb = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          host = lib.mkOption {
            default = "127.0.0.1";
            type = lib.types.str;
          };
          port = lib.mkOption {
            default = "8022";
            type = lib.types.str;
          };
          dbData = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
          };
          dbInfra = lib.mkOption {
            default = "";
            type = lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.dynamoDb;
  };
}
