using PetCareWebApi.Models.Base;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace PetCareWebApi.Models
    {
    [Table("horarioConsulta")]
    public class HorarioConsulta : BaseEntity
        {
        [Column("horario")]
        [DataType(DataType.Time)]
        [Required]
        public string? Horario { get; set; }
        [Column("disponibilidade")]
        [Required]
        public bool? Disponibilidade { get; set; }
        }
    }
