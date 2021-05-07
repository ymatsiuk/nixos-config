self: super:
{
  howdy = super.callPackage ./howdy { };
  pam_python = super.callPackage ./pam_python { };

  appgate-sdp = super.callPackage ./appgate-sdp { };

  teleport-ent = super.callPackage ./teleport-ent { };
}
