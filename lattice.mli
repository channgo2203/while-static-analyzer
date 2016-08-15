(** The lattice signature *)

module type S = 
sig 
  (** the type of the elements of the lattice *)
  type t 

  (** partial order boolean test *)
  val order_dec : t -> t -> bool

  (** lattice binary least upper bound *)
  val join : t -> t -> t

  (** lattice binary greatest lower bound *)
  val meet : t -> t -> t

  (** widening operator *)
  val widen : t -> t -> t

  (** narrowing operator *)
  val narrow : t -> t -> t

  (** [bottom ()] returns the least element of the lattice *)
  val bottom : unit -> t

  (** [top ()] returns the greatest element of the lattice *)
  val top : unit -> t

  (** string representation of the lattice elements *)
  val to_string : t -> string
end
