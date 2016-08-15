(** The lattice of abstract environment ordered with a point-wise partial order *)

module Make :
  functor (L : Lattice.S) ->
    sig
      module M : Map.S with type key = Syntax.var
      type t = L.t M.t

	  (** [update env x v] updates the abstract environment [env] with the variable [x] binded with the abstract value [v] *)
      val update : t -> M.key -> L.t -> t

	  (** [get env x] returns the abstract value binded with the variable [x] *)
      val get : t -> M.key -> L.t

      val order_dec : L.t M.t -> L.t M.t -> bool
      val join : L.t M.t -> L.t M.t -> L.t M.t
      val meet : L.t M.t -> L.t M.t -> L.t M.t
      val widen : L.t M.t -> L.t M.t -> L.t M.t
      val narrow : L.t M.t -> L.t M.t -> L.t M.t
      val vars : M.key list ref
      val init : M.key list -> unit
      val bottom : unit -> L.t M.t
      val top : unit -> L.t M.t
      val to_string : L.t M.t -> string
    end
