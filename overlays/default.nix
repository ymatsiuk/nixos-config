self: super:
{
  howdy = super.callPackage ./howdy { };
  pam_python = super.callPackage ./pam_python { };

  teleport-ent = super.callPackage ./teleport-ent { };
}
